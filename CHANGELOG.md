# Changelog

## Upcoming

- Add `prefix` option to state accessor methods ([#203](https://github.com/Freshly/flow/pull/203))
- Use Set instead of Array for accessor trackers ([#205](https://github.com/Freshly/flow/pull/205))

## 0.10.9

*Release Date*: 2021/6/16

- Remove explicit ActiveRecord dependency ([#200](https://github.com/Freshly/flow/pull/200))
- Add explicit dependency on `conjunction` (already a dependency of `malfunction`) ([#202](https://github.com/Freshly/flow/pull/202))

## 0.10.8

*Release Date*: 2021/6/3

- Use Substance objects if they're available ([#196](https://github.com/Freshly/flow/pull/196))

## 0.10.7.2

*Release Date*: 2021/5/11

- Fix `have_on_state` matcher for real ([#192](https://github.com/Freshly/flow/pull/192))

## 0.10.7.1

*Release Date*: 2021/4/13

- Fix `have_on_state` matcher for flow specs which don't use StateProxy ([#192](https://github.com/Freshly/flow/pull/192))

## 0.10.7 [Yanked]

*Release Date*: 2021/4/8

### Changes

- Updated rubocop, faker and other development dependencies

### Fixes

- Don't call deprecated reader methods from `have_on_state` matcher ([#189](https://github.com/Freshly/flow/pull/189))
- Ruby 2.7 fixes ([#190](https://github.com/Freshly/flow/pull/190))

## 0.10.6

*Release Date*: 2020/1/9

- Use `Conjunction` gem ([#152](https://github.com/Freshly/flow/pull/152))

## 0.10.5

*Release Date*: 2020/1/8

🚨 **Breaking Change**: Errors have been renamed and Flow concerns have been re-modularized!
⚠️ **Deprecation Warning**: Direct state access in Operations is being removed. [Learn more](./DEPRECATION_NOTICE.md)

- Add `StateProxy` to deprecate direct state access ([#128](https://github.com/Freshly/flow/pull/128))
- Add integration testing for State Accessors ([#135](https://github.com/Freshly/flow/pull/135))
- Add custom matchers for State Accessors and Document ([#136](https://github.com/Freshly/flow/pull/136))
- Re-modularized `Flow` concerns ([#149](https://github.com/Freshly/flow/pull/149))
- Refactor to use `Spicerack::RootObject` ([#145](https://github.com/Freshly/flow/pull/145))
- Consolidated errors under the root namespace ([#150](https://github.com/Freshly/flow/pull/150))

## 0.10.4

*Release Date*: 2020/1/7

- Operation failures log an `info` log instead of `error` ([#162](https://github.com/Freshly/flow/pull/162))

## 0.10.3

*Release Date*: 2019/9/27

- Delegate `operation_failure` to `flow.failed_operation` ([#125](https://github.com/Freshly/flow/pull/125))

## 0.10.2

*Release Date*: 2019/9/18

- Losen gemspec requirements to allow the Rails 6 suite ([#123](https://github.com/Freshly/flow/pull/123))
- Documentation updates
- Tweak operation spec generator

## 0.10.1

*Release Date*: 2019/6/14

- less pessimistic gemspec requirements [#109](https://github.com/Freshly/flow/pull/109)
- `with_failing_operation` shared context [#110](https://github.com/Freshly/flow/pull/110)
- allow triggering a flow with a provided state [#112](https://github.com/Freshly/flow/pull/112)

## 0.10.0

*Release Date*: 2019/5/12

- Namespace all constants under `Flow`
- Add new state attribute DSL [#58](https://github.com/Freshly/flow/pull/58)
- Add a bunch of new custom matchers 
- `handle_errors` method for operations [#85](https://github.com/Freshly/flow/pull/85)
- Allow nil values for passed-in arguments [#68](https://github.com/Freshly/flow/pull/68)
- State accessors [#63](https://github.com/Freshly/flow/pull/63)
- Remove rewind functionality [#83](https://github.com/Freshly/flow/pull/83)
- Proactive failure guard clauses [#67](https://github.com/Freshly/flow/pull/67)
- Adopt `spicerack-styleguide` in favor of hand-rolled rubocop
- Fix double run bug [#98](https://github.com/Freshly/flow/pull/98)
- Externalize the base of state gem [#100](https://github.com/Freshly/flow/pull/100)

## 0.9.3

*Release Date*: 2019/4/10

- Add define_context matcher
- Update docs

## 0.9.2

*Release Date*: 2019/4/3

- Bump spicerack version

## 0.3.0

*Release Date*: 2018/12/10

- Added Spicerack gem
- Added logging around flows and operations

## 0.2.0

*Release Date*: 2018/12/2

- FlowBase
- StateBase
- OperationBase

## 0.1.0

*Release Date*: 2018/11/29

- Initial commit (blank project)
