let project = new Project("New Project");
project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");

// Available Compiler Flags:
// S2D_PP -> enables Post-Processing
// S2D_PP_DOF -> enables Depth of Field PP effect
// S2D_PP_MIST -> enables Mist PP effect
// S2D_PP_FISHEYE -> enables Fisheye PP effect
// S2D_PP_FILTER -> enables 3x3 image convolution multi-pass PP effects
// S2D_PP_COMPOSITOR -> enables compositor / single-pass combination of various (AA, CC etc.) PP effects

resolve(project);
