// @ts-check
const path = require("node:path");
const fs = require("node:fs/promises");
const crypto = require("node:crypto");

/** actions/github-script でのリリース成果物のアップロード */
module.exports = async function ({ version, github, context, glob }) {
  const { data: release } = await github.rest.repos.createRelease({
    ...context.repo,
    tag_name: `v${version.replace(/^v/i, "")}`,
    prerelease: true,
    generate_release_notes: true,
  });

  const target = {
    ...context.repo,
    release_id: release.id,
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
    const body = `${release.body}

## OS イメージ

- ${name} (SHA256: \`${hash}\`)
`;

    await github.repos.updateRelease({ ...target, prerelease: false, body });
  }
};
