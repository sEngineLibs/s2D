let project = new Project('New Project');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

// S2D Compiler flags
project.addDefine("S2D_PP");
// project.addDefine("S2D_PP_DOF");
project.addDefine("S2D_PP_MIST");
project.addDefine("S2D_PP_FISHEYE");
project.addDefine("S2D_PP_FILTERS");
project.addDefine("S2D_PP_COMPOSITOR");

resolve(project);
