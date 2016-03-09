(function() {
  var Path, Q, fs, gm;

  Q = require('q');

  fs = require('fs-extra');

  gm = require('gm');

  Path = require('path');

  module.exports = function(server, config) {
    var get_ext;
    server.method('file.root', function() {
      return config.file.path;
    });
    server.method('file.safe_path', function(path, size) {
      if (size == null) {
        size = 2;
      }
      size = new RegExp(".{1," + size + "}", 'g');
      path = path.split(':');
      path[0] = path[0].match(size).join('/');
      return path.join('/');
    });
    get_ext = function(file) {
      var ext;
      return ext = Path.extname(typeof file === 'string' ? file : file.hapi.filename);
    };
    server.method('image.save', function(file, path, size) {
      var ensureDir, ext, opts;
      ext = get_ext(file);
      path = "" + path + ext;
      opts = {
        size: [],
        style: 'crop'
      };
      if (size instanceof Array) {
        opts.size = size;
      } else {
        opts = size;
      }
      ensureDir = function() {
        var deferred;
        deferred = Q.defer();
        fs.ensureDir(Path.dirname(path), function(err) {
          return deferred.resolve();
        });
        return deferred.promise;
      };
      return Q.fcall(ensureDir).then(function(err) {
        var deferred, process, writeStream;
        deferred = Q.defer();
        writeStream = fs.createWriteStream(path);
        writeStream.on('finish', function() {
          return deferred.resolve(path);
        });
        process = gm(file).resize(opts.size[0], opts.size[1], '^');
        if (opts.style === 'crop') {
          process.gravity('Center').crop(opts.size[0], opts.size[1]);
        }
        if (opts.blur != null) {
          process.blur(opts.blur[0], opts.blur[1]);
        }
        process.stream().pipe(writeStream);
        return deferred.promise;
      });
    });
    server.method('image.delete', function(path) {
      return Q.nfcall(fs.unlink, path);
    });
    server.method('image.replace', function(source, destination) {
      return Q.nfcall(fs.copy, source, destination, {
        replace: true
      }).then(function() {
        return Q.nfcall(fs.unlink, source);
      });
    });
    return server.method('image.rename', function(from, to) {
      return Q.nfcall(fs.rename, from, to);
    });
  };

}).call(this);
