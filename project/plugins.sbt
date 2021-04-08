addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.4.1")
addSbtPlugin("com.eed3si9n" % "sbt-buildinfo" % "0.10.0")

//for 'transactional' java project
resolvers += Resolver.jcenterRepo
addSbtPlugin("net.aichler" % "sbt-jupiter-interface" % "0.8.4")
