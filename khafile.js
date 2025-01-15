const fs = require("fs");
const path = require("path");
const cwd = process.cwd();
const verbose = process.verbose;

function clearDirectory(directory) {
    const files = fs.readdirSync(directory);

    files.forEach((file) => {
        const filePath = path.join(directory, file);
        const stat = fs.statSync(filePath);

        if (stat.isDirectory()) {
            clearDirectory(filePath);
            fs.rmdirSync(filePath);
        } else {
            fs.unlinkSync(filePath);
        }
    });
}

function copyDirectories(srcDir, destDir) {
    const files = fs.readdirSync(srcDir);
    files.forEach((file) => {
        const currentPath = path.join(srcDir, file);
        const targetPath = path.join(destDir, file);
        if (fs.statSync(currentPath).isDirectory()) {
            if (!fs.existsSync(targetPath)) {
                fs.mkdirSync(targetPath, { recursive: true });
            }
            copyDirectories(currentPath, targetPath);
        }
    });
}

function getAllShaders(dirPath) {
    let files = [];

    const items = fs.readdirSync(dirPath);

    items.forEach((item) => {
        const fullPath = path.join(dirPath, item);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            files = files.concat(getAllShaders(fullPath));
        } else if (stat.isFile() && fullPath.endsWith(".glsl")) {
            files.push(fullPath);
        }
    });

    return files;
}

function assembleShaders(shaderDir, outputDir) {
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    } else {
        clearDirectory(outputDir);
    }
    copyDirectories(shaderDir, outputDir);

    const shaderFiles = getAllShaders(shaderDir);
    let shaderFilesRelative = [];
    for (const shaderFile of shaderFiles)
        shaderFilesRelative.push(path.relative(shaderDir, shaderFile));

    shaderFilesRelative.forEach((shaderFile) => {
        function assemble(shaderFile) {
            if (verbose) {
                console.log(`Processing shader: ${shaderFile}`);
            }

            const shaderPath = path.join(shaderDir, shaderFile);
            const outputPath = path.join(outputDir, shaderFile);

            if (!fs.existsSync(outputPath)) {
                const includeRegex = /^\s*#include\s+"(.+)"\s*$/gm;
                let shaderSource = fs.readFileSync(shaderPath, "utf8");
                let match;
                while ((match = includeRegex.exec(shaderSource)) !== null) {
                    const includePath = `${path.resolve(
                        outputDir,
                        match[1]
                    )}.glsl`;
                    if (!fs.existsSync(includePath)) {
                        try {
                            assemble(`${match[1]}.glsl`);
                        } catch (e) {
                            console.log(
                                `Failed to include: ${includePath}: ${e}`
                            );
                            return;
                        }
                    }

                    const includeContent = fs.readFileSync(includePath, "utf8");
                    shaderSource = shaderSource.replace(
                        match[0],
                        includeContent
                    );
                }

                fs.writeFileSync(outputPath, shaderSource, "utf8");
            }
        }

        assemble(shaderFile);
    });
}

const shaderInputDir = path.join(__dirname, "shaders");
const shaderOutputDir = path.join(cwd, "build", "shaders_assembled");
assembleShaders(shaderInputDir, shaderOutputDir);

let project = new Project("s2D");

project.addSources("src");
project.addAssets("assets/**", {
    nameBaseDir: "assets",
    destination: "assets/{dir}/{name}",
    name: "{name}",
});

// Available Engine Compiler Flags:

// Debug:
// S2D_DEBUG_FPS -> enables FPS debugging

// Renderer:
// S2D_RP_ENV_LIGHTING -> enables environment lighting
// S2D_PP_BLOOM -> enables Bloom PP effect
// S2D_PP_DOF -> enables Depth of Field PP effect
// S2D_PP_DOF_QUALITY_LEVEL -> sets the quality level of DOF effect (0 - low, 1 - middle, 2 - high)
// S2D_PP_MIST -> enables Mist PP effect
// S2D_PP_FISHEYE -> enables Fisheye PP effect
// S2D_PP_FILTERS -> enables 3x3 image convolution multi-pass PP effects
// S2D_PP_COMPOSITOR -> enables compositor / single-pass combination of various (AA, CC etc.) PP effects
let defs = [];
for (const def of process.defines) {
    let kv = def.split(" ");
    if (kv.length === 2) {
        project.addDefine(`${kv[0]}=${kv[1]}`);
        defs.push(`${kv[0]} ${kv[1]}`);
    } else {
        project.addDefine(def);
        defs.push(`${kv[0]} 1`);
    }
}

project.addShaders(`${shaderOutputDir}/**/*{frag,vert}.glsl`, {
    defines: defs,
});

resolve(project);
