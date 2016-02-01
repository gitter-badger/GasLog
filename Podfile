platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'Alamofire', '~> 3.0'
    pod 'RealmSwift', '~> 0.97'
    # pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift2'
    pod 'SDWebImage', '~> 3.7'
    pod 'UICKeyChainStore', '~> 2.0'
    pod 'DZNEmptyDataSet', '~> 1.7'
    pod 'SVProgressHUD'
    pod 'SwiftMoment', '~> 0.2'
    # pod 'FMDB', '~> 2.5' # temp for migration.
    pod 'Material', '~> 1.29'
end

target 'Gas Log' do
    shared_pods
end

target 'GasLoggerTests' do
    shared_pods
end

target 'GasLoggerUITests' do
    shared_pods
end
