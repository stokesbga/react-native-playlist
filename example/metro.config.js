let path = require("path")

module.exports = {
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: false
      }
    })
  },
  resolver: {
    /* This configuration allows you to build React-Native modules and
     * test them without having to publish the module. Any exports provided
     * by your source should be added to the "target" parameter. Any import
     * not matched by a key in target will have to be located in the embedded
     * app's node_modules directory.
     */
    extraNodeModules: new Proxy(
      /* The first argument to the Proxy constructor is passed as
       * "target" to the "get" method below.
       * Put the names of the libraries included in your reusable
       * module as they would be imported when the module is actually used.
       */
      {
        "react-native-playlist": path.resolve(__dirname, "../")
      },
      {
        get: (target, name) => {
          if (target.hasOwnProperty(name)) {
            return target[name]
          }
          return path.join(process.cwd(), `node_modules/${name}`)
        }
      }
    )
  },
  projectRoot: path.resolve(__dirname),
  watchFolders: [
    path.resolve(__dirname, "../"),
    path.resolve(__dirname, "./node_modules")
  ]
}
