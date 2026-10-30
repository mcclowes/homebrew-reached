# Reached CLI

Install on macOS or Linux:

```sh
brew install mcclowes/reached/reached
reached --help
```

The CLI calls the same authenticated API as the apps. It never accesses the database directly.
Set `REACHED_TOKEN` to a current Clerk session JWT for your Reached account. For now,
obtain it from a signed-in Reached browser's developer console with
`await window.Clerk.session.getToken()`, then enter it without putting it in shell history:

```sh
read -rs REACHED_TOKEN
export REACHED_TOKEN
reached home
reached contacts list --query 'Ada London' --json
reached contacts get CONTACT_ID
reached interactions list --contact CONTACT_ID
reached follow-ups list --contact CONTACT_ID
reached events list
```

Clerk session tokens expire quickly. Get a new token when the CLI reports an expired
session. Persistent terminal sign-in and automatic renewal aren't included in this
release. Tokens are never saved by the CLI. `REACHED_URL` overrides the default
`https://reached.marginalutility.dev`; use only a server you trust with your token.
Local development can use `http://localhost:3000`.

Writes take an API-shaped JSON object, inline or through stdin:

```sh
printf '%s' '{"firstName":"Ada","lastName":"Lovelace"}' | reached contacts create --data -
reached contacts update CONTACT_ID --data '{"notes":"Met at the conference"}'
reached contacts delete CONTACT_ID --yes
```

`interactions create`, `follow-ups save`, and `follow-ups complete` also accept
`--data`. Follow-up saves require `id`, `contactId`, `title`, `dueOn`, `revision`,
and `completed`; new rows use a fresh ID and revision 0, and updates use the last
returned revision. Completion requires `id`, `contactId`, `revision`, and `completed`.
Conflicts return HTTP 409; reload before retrying. Failed writes are never retried
automatically because the server may have saved them before the response was lost.

Output is JSON, formatted by default and compact with `--json`. Diagnostics go to
stderr. Exit codes are 0 for success, 1 for request/configuration failures, and 2
for invalid usage. Redirects are rejected, and requests time out after 30 seconds.

## Development and releases

From the repo root:

```sh
npm run test --workspace=apps/cli
npm run build --workspace=apps/cli
node apps/cli/build/cli.js --help
node scripts/release-cli.mjs
```

The release script checks, compiles, and packages only the CLI executable and this
README, creates a public release in `mcclowes/homebrew-reached`, then updates the
checksum-pinned formula. The private application source isn't published. Increase
the version in both `package.json` and `src/cli.ts` before the next release.
Publishing requires GitHub CLI authentication with repository/release write access.
