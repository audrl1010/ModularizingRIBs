xcodegen -s ./Projects/Common/project.yml
xcodegen -s ./Projects/TaskEditing/project.yml
xcodegen -s ./Projects/Tasks/project.yml
xcodegen -s ./Projects/App/project.yml

bundle exec pod install || bundle exec pod install --repo-update
