xcodegen -s ./Projects/Common/project.yml
xcodegen -s ./Projects/Detail/project.yml
xcodegen -s ./Projects/List/project.yml
xcodegen -s ./Projects/App/project.yml

bundle exec pod install || bundle exec pod install --repo-update
