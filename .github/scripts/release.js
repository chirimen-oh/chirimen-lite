const path = require("path");
const fs = require("fs").promises;
const crypto = require("crypto");

/** actions/github-script でのリリース成果物のアップロード */
module.exports = async function ({ github, context, glob, io }) {
  const target = {
    ...context.repo,
    release_id: context.payload.release.id,
  };

  const globber = await glob.create("deploy/image_*.zip");

  for await (const file of globber.globGenerator()) {
    const name = path.basename(file).replace(/^image_/, "");
    const data = await fs.readFile(file);

    await github.repos.uploadReleaseAsset({
      ...target,
      name,
      data,
    });

    const hash = crypto.createHash("sha256").update(data).digest("hex");

    await github.repos.updateRelease({
      ...target,
      prerelease: false,
      body: [
        context.payload.release.body,
        "OS イメージ",
        "",
        `- ${name} (SHA256: \`${hash}\`)`,
      ].join("\n"),
    });
  }
};
