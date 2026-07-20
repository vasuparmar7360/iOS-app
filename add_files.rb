require 'xcodeproj'
project_path = '/Users/vasuparmar/Desktop/game_ios/CodeXNebula.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Add Models
models_group = project.main_group.find_subpath(File.join('CodeXNebula', 'Backend', 'Models'), true)
['Friend.swift', 'BattlePlayer.swift', 'Battle.swift', 'BattleInvitation.swift'].each do |file|
  path = "CodeXNebula/Backend/Models/#{file}"
  file_ref = models_group.new_file(path)
  target.source_build_phase.add_file_reference(file_ref)
end

# Add Services
services_group = project.main_group.find_subpath(File.join('CodeXNebula', 'Backend', 'Services'), true)
['BattleService.swift'].each do |file|
  path = "CodeXNebula/Backend/Services/#{file}"
  file_ref = services_group.new_file(path)
  target.source_build_phase.add_file_reference(file_ref)
end

# Add ViewModels
viewmodels_group = project.main_group.find_subpath(File.join('CodeXNebula', 'Backend', 'ViewModels'), true)
['BattleViewModel.swift'].each do |file|
  path = "CodeXNebula/Backend/ViewModels/#{file}"
  file_ref = viewmodels_group.new_file(path)
  target.source_build_phase.add_file_reference(file_ref)
end

# Add Views
battle_views_group = project.main_group.find_subpath(File.join('CodeXNebula', 'Frontend', 'Views', 'Battle'), true)
['BattleHomeView.swift', 'BattleLobbyView.swift', 'FriendListView.swift', 'InviteFriendView.swift', 'WaitingRoomView.swift'].each do |file|
  path = "CodeXNebula/Frontend/Views/Battle/#{file}"
  file_ref = battle_views_group.new_file(path)
  target.source_build_phase.add_file_reference(file_ref)
end

project.save
