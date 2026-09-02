# Cursor iOS Rules

Battle-tested [Cursor](https://cursor.com) agent rules for **iOS and macOS** development. SwiftUI, UIKit, App Store shipping, and agent discipline in one copy-paste pack.

Use this as your default `.cursor/rules/` starter when starting an Apple platform project, or install globally for every repo on your machine.

## What's inside

| Rule | Activation | Purpose |
|------|------------|---------|
| `swiftui.mdc` | Glob (SwiftUI files) | MVVM, state, concurrency, previews |
| `uikit-ios.mdc` | Glob (UIKit files) | Programmatic UIKit, display models, layout |
| `ios-swift-general.mdc` | Glob (Swift, Xcode project files) | SPM, XcodeGen, build habits, deployment targets |
| `app-store-shipping.mdc` | Glob (plist, LISTING, app-store docs) | Version bumps, screenshots, pre-upload checklist |
| `app-store-copy.mdc` | Glob (listing / strings) | Human App Store copy, no AI tells |
| `anti-overengineering.mdc` | **Always on** | Scoped diffs, no architecture theater |
| `agent-honesty.mdc` | **Always on** | Verify APIs, no false "looks good" |
| `agent-efficiency.mdc` | **Always on** | Grep before read, risk-based builds, stop when done |

Three rules are always-on by design (~150 lines total). The rest load only when you touch matching files, so token cost stays low.

## Quick install

### Option A: Global (all projects on this Mac)

```bash
git clone https://github.com/kkarimz/cursor-ios-rules.git
cursor-ios-rules/install.sh user
```

Copies to `~/.cursor/rules/`. Good for solo dev; watch the always-on token budget (see below).

### Option B: One project

```bash
git clone https://github.com/kkarimz/cursor-ios-rules.git
cd YourApp
/path/to/cursor-ios-rules/install.sh project
```

This copies rules to `YourApp/.cursor/rules/`. Commit that folder so your team gets the same agent behavior.

### Option C: Submodule + symlink

```bash
git submodule add https://github.com/kkarimz/cursor-ios-rules.git .cursor/cursor-ios-rules
./.cursor/cursor-ios-rules/install.sh link
```

Updates when you bump the submodule.

## Verify rules loaded

1. Open **Cursor Settings → Rules** or the agent context panel.
2. Open a Swift file and start an agent chat.
3. You should see glob rules like `swiftui.mdc` attach when editing `*View.swift`.
4. Always-on rules (`agent-efficiency`, etc.) appear in every agent session.

Rules apply to **Agent (Chat / Composer)** and the **Cursor CLI agent**. They do not apply to Tab completion or Cmd+K inline edit.

## Recommended setup for iOS teams

**Per-project (best for teams):**

```
YourApp/
  .cursor/
    rules/          ← copy from this repo
  docs/
    app-store/
      LISTING.md    ← source of truth for App Store copy
```

**Solo dev:**

- Global install (`install.sh user`) plus project-specific overrides in `YourApp/.cursor/rules/` when needed.

**Fork and customize:**

- Change globs if your folder layout differs (`Sources/`, `App/`, etc.).
- Set `alwaysApply: false` on agent rules if context feels heavy.
- Add your team's signing team ID, scheme names, or CI commands as a local `ios-team.mdc` (gitignored or private).

## Token budget

Always-on rules load on **every agent turn**. Keep them short.

| If context feels heavy | Do this |
|------------------------|---------|
| Rules bucket is large | Flip `agent-honesty` or `agent-efficiency` to `alwaysApply: false` |
| Working on non-Apple code in a monorepo | Use project install, not global |
| Long chat | `/summarize` or start a new chat |
| Unused MCP servers | Disable in Cursor settings |

Cursor 3.3+ shows a **context ring** next to the prompt with a per-bucket breakdown (Rules, Skills, MCP, conversation).

## Rule details

### SwiftUI (`swiftui.mdc`)

- Views render state; no networking in `body`
- `@State` / `@StateObject` / `@Environment` used correctly
- `.task(id:)` over bare `.onAppear` for async work
- `#Preview` for non-trivial views

### UIKit (`uikit-ios.mdc`)

- Programmatic layout, Safe Area, Dynamic Type
- Display models into views, not domain types
- Closures and delegates for events; `[weak self]` when needed

### iOS / Swift general (`ios-swift-general.mdc`)

- SPM-first; respect `Package.resolved`
- XcodeGen: edit `project.yml`, not hand-hack `pbxproj`
- `@MainActor` for UI; async in new code when target allows

### App Store shipping (`app-store-shipping.mdc`)

- Bump version in **Info.plist + project.yml + pbxproj** together
- LISTING.md drives What's New
- Screenshot sizes from source captures, not upscaled thumbnails

### Agent discipline (always on)

Adapted from production use shipping Mac and iOS apps with Cursor Agent:

- **Anti-overengineering:** smallest diff that works
- **Agent honesty:** verify `Package.swift` symbols before using them
- **Agent efficiency:** grep before read; build only what the change risk requires

## Cursor CLI

The CLI agent reads project `.cursor/rules/` the same way as the desktop app:

```bash
cd YourApp
cursor agent "fix the SwiftUI preview crash in DocumentView"
```

User rules in **Cursor Settings → Rules** also apply globally in both app and CLI.

## Contributing

PRs welcome for:

- Additional globs (Tuist, Bazel, fastlane paths)
- watchOS / tvOS / visionOS variants
- Tighter always-on rules (same intent, fewer words)

Please keep one concern per `.mdc` file and include frontmatter (`description`, `globs`, `alwaysApply`).

## License

MIT. See [LICENSE](LICENSE).

## Related

- [Cursor Rules docs](https://cursor.com/docs/context/rules)
- [claude-ios-rules](https://github.com/kkarimz/claude-ios-rules) (Claude Code equivalent)
- [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules) (broader community catalog)

---

**Not affiliated with Apple or Cursor.** Rules are opinions from real app shipping workflows. Adjust for your team.
