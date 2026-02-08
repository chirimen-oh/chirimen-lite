// @ts-check
const path = require("node:path");
const fs = require("node:fs/promises");
const crypto = require("node:crypto");

/** actions/github-script でのリリース成果物のアップロード */
module.exports = async function ({ version, ref, github, context, glob }) {
  // Extract branch name from ref (e.g., refs/heads/master -> master)
  const branch = ref ? ref.replace(/^refs\/heads\//, "") : undefined;
  
  const { data: release } = await github.rest.repos.createRelease({
    ...context.repo,
    tag_name: `v${version.replace(/^v/i, "")}`,
    target_commitish: branch,
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

    await github.rest.repos.uploadReleaseAsset({
      ...target,
      name,
      data,
    });

    const hash = crypto.createHash("sha256").update(data).digest("hex");
    const body = `${release.body}

## OS イメージ

- ${name} (SHA256: \`${hash}\`)
`;

    await github.rest.repos.updateRelease({ ...target, prerelease: false, body });
  }
};
