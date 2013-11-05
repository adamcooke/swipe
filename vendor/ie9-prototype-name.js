/* Some older versions of Internet Exporer do not support Function.prototype.name
   upon which Swipe relies. This emulates it. */

if (Function.prototype.name === undefined && Object.defineProperty !== undefined) {
  Object.defineProperty(Function.prototype, 'name', {
    get: function() {
      var funcNameRegex = /function\s+(.{1,})\s*\(/;
      var results = (funcNameRegex).exec((this).toString());
      return (results && results.length > 1) ? results[1] : "";
    },
    set: function(value) {}
  });
}