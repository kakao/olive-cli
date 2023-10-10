OLIVE CLI
==============================================================================

## 개요

OLIVE CLI는 사용자 PC 환경에서 OLIVE Platform의 기능을 실행할 수 있도록 돕는 CLI(Command Line Interface) 도구입니다.
CLI를 사용하면 터미널 프로그램의 명령 프롬프트에서도 브라우저 기반 OLIVE Platform과 동일하게 오픈소스를 스캔할 수 있습니다.

> **★ 참고:**
> - OLIVE CLI의 사용법, 명령어 등에 대한 자세한 설명은 [사용자 문서](https://olive.kakao.com/docs/cli/v2/overview) 를 참고해 주세요.
> - OLIVE CLI를 통해 OLIVE의 기능을 사용하기 위해서는 먼저 OLIVE에서 API 토큰을 발급받아야 합니다. 발급 방법은 다음의 [API 토큰 발급하기](https://olive.kakao.com/docs/cli/v2/overview/#api-%ED%86%A0%ED%81%B0-%EB%B0%9C%EA%B8%89%ED%95%98%EA%B8%B0)를 참고해 주세요.
> - OLIVE CLI 다운로드는 [OLIVE CLI 실행하기](https://olive.kakao.com/docs/cli/v2/overview/#olive-cli-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0)를 참고해주세요.

OLIVE CLI는 보안상 웹서비스 사용이 어렵거나, 소스코드 노출이 우려되는 경우 안심하고 사용할 수 있습니다. 특장점은 다음과 같습니다.

* VCS(Version Control System)에 종속되지 않고 프로젝트를 사용자 PC 환경에서 분석
* 분석한 결과를 사용자 PC 에서 별도 파일로 관리
* 명령어를 이용해 분석된 결과를 업로드하여 OLIVE Platform 프로젝트로 관리
* 소스코드가 전송되지 않음
* 특정 명령어(`report` 및 `apply`)를 수행하지 않으면 클라이언트 측의 어떤 데이터도 서버에 저장되지 않음


## 면책조항

카카오는 OLIVE CLI 를 통해 제공되는 모든 정보의 정확성, 신뢰도 등에 대해 어떠한 보증도 하지 않습니다.
사용자는 전적으로 자기 책임 하에 OLIVE CLI 와 OLIVE Platform 을 사용하고, 카카오는 이와 관련하여 사용자 및 제3자에 대해 어떠한 책임도 지지 않습니다.

## Quick Links
- [OLIVE Platform](https://olive.kakao.com)
- [OLIVE CLI 사용자 문서](https://olive.kakao.com/docs/cli/v2/overview)
- [Relaese Note](https://github.com/kakao/olive-cli/releases)
- 문의하기 : <a href="http://pf.kakao.com/_ztlfK/chat"><img src="https://t1.kakaocdn.net/together_image/svg/footer_kakaotalk.svg" height="16px" width="16px"></a>&nbsp;&nbsp;&nbsp;[✉](mailto:opensource@kakaocorp.com)
