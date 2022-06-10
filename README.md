OLIVE CLI
==============================================================================

## 개요

OLIVE CLI는 사용자 PC 환경에서 OLIVE Platform의 기능을 실행할 수 있도록 돕는 CLI(Command Line Interface) 도구입니다.<br/>
CLI를 사용하면 터미널 프로그램의 명령 프롬프트에서도 브라우저 기반 OLIVE Platform과 동일하게 오픈소스를 스캔할 수 있습니다.

> **★ 참고:**<br>
> - OLIVE CLI를 통해 OLIVE의 기능을 사용하기 위해서는 먼저 OLIVE에서 API 토큰을 발급받아야 합니다. 발급 방법은 다음의 [API 토큰 발급하기](#API-토큰-발급하기)를 참고해 주세요.
> - OLIVE CLI 다운로드는 [여기](https://github.com/kakao/olive-cli/releases)를 참고해주세요.

OLIVE CLI는 보안상 웹서비스 사용이 어렵거나, 소스코드 노출이 우려되는 경우 안심하고 사용할 수 있습니다. 특장점은 다음과 같습니다.

* VCS(Version Control System)에 종속되지 않고 프로젝트를 사용자 PC 환경에서 분석
* 분석한 결과를 사용자 PC 에서 별도 파일로 관리
* 명령어를 이용해 분석된 결과를 업로드하여 OLIVE Platform 프로젝트로 관리
* 소스코드가 전송되지 않음
* 특정 명령어(`report` 및 `apply`)를 수행하지 않으면 클라이언트 측의 어떤 데이터도 서버에 저장되지 않음

  > **★ 참고:**<br/>`report` 및 `apply` 명령어 수행 시 저장되는 정보는 다음과 같습니다.
  >
  > - [`report` 명령어 수행 시 저장되는 정보](https://olive.kakao.com/docs/cli/commands#report)
  > - [`apply` 명령어 수행 시 저장되는 정보](https://olive.kakao.com/docs/cli/commands#apply)

## 면책조항

카카오는 OLIVE CLI 를 통해 제공되는 모든 정보의 정확성, 신뢰도 등에 대해 어떠한 보증도 하지 않습니다.
사용자는 전적으로 자기 책임 하에 OLIVE CLI 와 OLIVE Platform 을 사용하고, 카카오는 이와 관련하여 사용자 및 제3자에 대해 어떠한 책임도 지지 않습니다.

## Quick Links
- [OLIVE Platform](https://olive.kakao.com)
- [OLIVE CLI 사용자 문서](https://olive.kakao.com/docs/cli/overview)
- [Relaese Note](https://github.com/kakao/olive-cli/releases)

## OLIVE CLI 실행하기

OLIVE CLI는 환경별로 최신 배포된 바이너리를 다운로드해 별도 설치 과정 없이 바로 사용할 수 있습니다.

> **★ 참고:**<br>
> 실행 시 다운로드한 OLIVE CLI 바이너리 파일의 경로(Path)를 전역 환경변수로 지정해 사용하는 것을 권장합니다.

### OLIVE CLI 다운로드 위치

다음의 Kakao GitHub 레포지토리에서 다운로드할 수 있습니다.

* **OLIVE CLI 다운로드 위치:** https://github.com/kakao/olive-cli/releases

### 설정하기

사용하는 OS 환경에 맞게 실행 권한을 추가해야 합니다.

#### Linux 및 Mac OS 공통

다음과 같이 실행 권한을 추가할 수 있습니다.

```bash
$ chmod +x olive-cli
```

#### Mac OS 환경

Mac OS 환경에서는 실행 시 확인되지 않은 개발자 배포 이슈가 나올 경우, [시스템 환경설정]  > [보안 및 개인 정보]에서 **확인 없이 열기**를 클릭하여 실행합니다.

### 실행 전 주의사항

OLIVE CLI 수행 시 특정 명령어에서 OLIVE Platform API 호출이 필요합니다. 방화벽이 있다면 다음 URL에 대한 아웃바운드(Outbound) 설정을 추가해야 합니다.

| 명령어          | 메서드 | API URL                                           |
| --------------- | ------ | ------------------------------------------------- |
| `mapping`       | `POST` | https://olive-api.kakao.com/api/v1/cli/mapping    |
| `report`        | `POST` | https://olive-api.kakao.com/api/v1/cli/report     |
| `apply`         | `POST` | https://olive-api.kakao.com/api/v1/cli/apply      |
| `add component` | `POST` | https://olive-api.kakao.com/api/v1/cli/components |
| `notice`        | `PUT`  | https://olive-api.kakao.com/api/v1/cli/notices    |

### 실행 화면

OLIVE CLI를 실행하면 다음과 같은 프롬프트 화면이 나타납니다.

```bash
   ____  __    _____    ________   ________    ____
  / __ \/ /   /  _/ |  / / ____/  / ____/ /   /  _/
 / / / / /    / / | | / / __/    / /   / /    / /
/ /_/ / /____/ /  | |/ / /___   / /___/ /____/ /
\____/_____/___/  |___/_____/   \____/_____/___/

Usage:

olive-cli [-hV] [COMMAND]

Description:

OLIVE CLI

Options:
  -h, --help      Show this help message and exit.
  -V, --version   Print version information and exit.
Commands:
  init       Initialize olive-cli configuration styles
  analyze    Analyzing the dependencies used in project
  mapping    Mapping components based on analysis results
  component  Shows the component list
  license    Shows the license list
  add        Add manual things in scan
  report     Report the analysis results.
  apply      Apply the results of analysis.
  notice     Download the preview of opensource software notice.
  status     Shows the current status
  help       Displays help information about the specified command
```

## 명령어 목록

다음은 OLIVE CLI 명령어 목록입니다. 자세한 설명을 확인하려면 각 명령어를 클릭해 주세요.

| 명령어                                                  | 설명                                                          |
| ------------------------------------------------------| ------------------------------------------------------------ |
| [`init`](https://olive.kakao.com/docs/cli/commands#init)                     | OLIVE CLI 사용을 위한 초기 설정을 진행하며, `config.yaml` 설정파일이 생성됩니다. |
| [`analyze`](https://olive.kakao.com/docs/cli/commands#analyze)               | `config.yaml` 설정파일 기반으로 의존성 분석을 시작합니다. <br/>분석이 완료되면 `dependency.json`, `dependency.csv` 파일이 생성됩니다. |
| [`mapping`](https://olive.kakao.com/docs/cli/commands#mapping)               | `analyze` 명령어로 분석된 의존성을 컴포넌트에 매핑합니다. <br/>매핑이 완료되면 `mapping.json` `mapping.csv`, `unmapping.csv` 파일이 생성됩니다. |
| [`component`](https://olive.kakao.com/docs/cli/commands#component)           | 프로젝트가 사용한 컴포넌트를 조회합니다. <br/>조회가 완료되면 `component.json`, `component.csv` 파일이 생성됩니다.                     |
| [`license`](https://olive.kakao.com/docs/cli/commands#license)               | 프로젝트가 사용한 컴포넌트의 라이선스를 조회합니다. <br/>조회가 완료되면 `license.json`, `license.csv` 파일이 생성됩니다.                                |
| [`add component`](https://olive.kakao.com/docs/cli/commands#add-component)   | 사용자가 수동으로 컴포넌트를 추가합니다.                     |
| [`report`](https://olive.kakao.com/docs/cli/command#report)                 | 매핑이 되지 않은 의존성 목록을 관리자에게 전송합니다.<br/><br/>★<b>참고:</b> 관리자가 해당 데이터를 리뷰하고 `mapping` 명령어를 다시 수행하여 컴포넌트에 매핑할 수 있습니다. |
| [`apply`](https://olive.kakao.com/docs/cli/commands#apply)                   | CLI 분석한 결과를 토대로 OLIVE Platform에 프로젝트를 생성합니다. |
| [`notice`](https://olive.kakao.com/docs/cli/commands#notice)                 | 프로젝트가 사용한 컴포넌트를 기반으로 고지문 미리보기를 생성합니다. |
| [`status`](https://olive.kakao.com/docs/cli/commands#status)                 | 현재 프로젝트 상태를 조회할 수 있습니다.                     |

## API 토큰 발급하기

OLIVE CLI를 사용하기 위해서는 API 토큰이 필요합니다.

API 토큰은 [OLIVE Platform](https://olive.kakao.com) **마이페이지** 하위의 **Token 설정** 탭에서 생성할 수 있습니다.

![token-generate](https://user-images.githubusercontent.com/2889542/164443414-f3c8d683-32b7-4bb9-9901-70050385bc18.png)

## 분석 가능 시스템

현재 분석 가능한 시스템은 다음과 같습니다. 다양한 시스템을 지원하도록 계속 업데이트할 예정입니다.

| 번호 | 패키지 매니저 타입 | 분석 타입 | 의존성 타입       | 분석 대상 파일           |
| ---- | ------------------ | --------- | ----------------- | ------------------------ |
| 1    | MAVEN              | BUILDER   | GRADLE            | -                        |
| 2    | MAVEN              | BUILDER   | GRADLE_KTS        | -                        |
| 3    | MAVEN              | PARSER    | GRADLE            | *.gradle             |
| 4    | MAVEN              | PARSER    | GRADLE_KTS        | *.gradle.kts               |
| 5    | MAVEN              | PARSER    | POM_XML           | pom.xml                  |
| 6    | COCOAPOD          | PARSER    | PODFILE           | Podfile, podfile         |
| 7    | COCOAPOD          | PARSER    | PODSPEC           | .podspec         |
| 8    | SWIFT_PM           | PARSER    | PACKAGE_SWIFT     | Package.swift            |
| 9    | RUBY_GEM           | PARSER    | GEMFILE           | Gemfile                  |
| 10   | PYPI               | PARSER    | SETUP_PY          | setup.py                 |
| 11   | PYPI               | PARSER    | REQUIREMENT_TXT   | requirements.txt         |
| 12   | NPM                | PARSER    | PACKAGE_JSON      | package.json             |
| 13   | GO_PACKAGE         | PARSER    | GODEP_JSON        | Godeps.json |
| 14   | GO_PACKAGE         | PARSER    | GOPKG_TOML        | Gopkg.toml               |
| 15   | GO_PACKAGE         | PARSER    | GOPKG_LOCK        | Gopkg.lock               |
| 16   | GO_PACKAGE         | PARSER    | GO_MODULE         | go.mod                   |
| 17   | SUPERMARKET        | PARSER    | BERKSFILE         | Berksfile                |
| 18   | MAKE               | PARSER    | CMAKE_LIST_TXT    | CMakeLists.txt           |
| 19   | MAKE               | PARSER    | ANDROID_MAKE      | Android.mk               |
| 20   | SUBMODULE          | PARSER    | GIT_MODULES       | .gitmodules              |
| 21   | USER_DEFINED       | PARSER    | DEPENDENCY_MAVEN   | dependencyTree.maven       |
| 22   | USER_DEFINED       | PARSER    | DEPENDENCY_SCALA  | dependencyTree.scala       |
| 23   | FRAMEWORK          | SEARCHER  | BINARY            | *.framework              |
| 24   | LIBRARY            | SEARCHER  | BINARY            | *.lib, *.jar, *.dll ...  |
| 25   | CARTHAGE           | PARSER    | CARTFILE          | Cartfile                 |

### Apple Frameworks를 사용한 경우

OLIVE CLI(v1.0.0)에서는 [Apple Fromeworks](https://olive.kakao.com/component/detail?id=2043) 컴포넌트 자동 매핑을 지원하지 않고 있습니다. <br/>
추후 개선될 예정이며, 다음의 정보를 참고하여 [`add component`](https://olive.kakao.com/docs/cli/commands#add-component) 명령어로 수동 추가해 주시길 바랍니다.

```
---
manual-components:
- path: “/”                                         # 컴포넌트를 사용한 위치
  url: “https://developer.apple.com/documentation”  # 추가하고자 하는 컴포넌트 URL
```
