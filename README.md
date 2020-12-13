# ModularizingRIBs

## 프로젝트 설정

```bash
$ brew install
$ bundle install
$ pip install pipenv
$ ./setup.sh
```

## 프레임워크 템플릿 이용하는 방법

```bash

$ make framework
```

## 프로젝트 구조

App
RIB들을 조립하는 하여 실제 구동 되는 앱이다.

Tasks (Viewable RIB)
Task 리스트를 보여주는 기능 제공

- static framework

TaskEditing (Viewable RIB)
Task를 추가 하거나 수정할 수 있는 기능 제공

- static framework

Common
공유해야 하는 파일들을 모아 놓는 곳
다음 폴더들을 포함하고 있다.

- Models: 모델들
- Components: UI 컴포넌트들
- DIContainers: Repository DI Container, RIBs DI Container
- Repositories: 레파지토리들
- Utils: 유틸리티들
- dynamic framework
