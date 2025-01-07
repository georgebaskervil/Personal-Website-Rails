module.exports = {
  ecma: 5,
  warnings: true,
  mangle: {
    properties: false,
    safari10: true,
    toplevel: false, // Disable toplevel mangling for legacy compatibility
  },
  compress: {
    defaults: true,
    arrows: false, // Disable arrow function compression for legacy compatibility
    booleans_as_integers: false, // Disable boolean as integers for legacy compatibility
    booleans: true,
    collapse_vars: true,
    comparisons: true,
    conditionals: true,
    dead_code: true,
    drop_console: false,
    directives: true,
    evaluate: true,
    hoist_funs: true,
    if_return: true,
    join_vars: true,
    keep_fargs: false, // Drop unused function arguments
    loops: true,
    negate_iife: true,
    passes: 3, // Additional passes can catch more opportunities for compression
    properties: true,
    reduce_vars: true,
    sequences: true,
    side_effects: true, // But be careful, this might remove functions with no apparent side effects
    toplevel: false, // Disable toplevel compression for legacy compatibility
    typeofs: false, // Disable typeof compression for legacy compatibility
    unused: true, // Drop unused variables and functions
  },
  output: {
    comments: /(?:copyright|licence|©)/i,
    beautify: false,
    semicolons: true,
  },
  keep_classnames: false,
  keep_fnames: false,
  safari10: true,
  module: true,
};
