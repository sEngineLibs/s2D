let project = new Project("SUI");

project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");
project.addParameter("-dce full");

// -> SUI Compiler Flags
// --> Debugging
project.addDefine("S2D_DEBUG_FPS");
// TODO:
// project.addDefine('S2D_DEBUG_BOUNDS');

// -> SUI S2D Compiler Flags
// --> Debugging
// project.addDefine('S2D_DEBUG_CONSOLE');
// project.addDefine('S2D_DEBUG_GBUFFER');
// project.addDefine('S2D_DEBUG_LIGHTS');
// project.addDefine('S2D_DEBUG_COLLISIONS');

// --> Shading
project.addDefine("S2D_SHADING_DEFERRED");
// project.addDefine('S2D_SHADING_FORWARD');
// project.addDefine('S2D_SHADING_MIXED');

// --> Misc
project.addDefine("S2D_BATCHING");

resolve(project);
