require 'rake/testtask'

task :default => 'test:all'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/*_spec.rb']
  t.warning = true
end

Rake::TestTask.new do |t|
  t.libs = ["lib", "spec"]
  t.name = "test:integration"
  t.warning = true
  t.test_files = FileList['spec/integration/*_spec.rb']
end

Rake::TestTask.new("test:all") do |t|
  t.libs = ["lib", "spec"]
  t.test_files = FileList['spec/**/*_spec.rb']
end

