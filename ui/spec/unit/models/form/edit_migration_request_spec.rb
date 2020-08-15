require 'unit_helper'
require 'active_support/core_ext/hash'

require 'form/migration_request'
require 'form/edit_migration_request'

RSpec::Matchers.define :have_error_on do |expected|
  match do |actual|
    actual.errors[expected].any?
  end
end

RSpec.describe Form::EditMigrationRequest do
  let(:dao) { double('Migration').as_null_object }
  def build(extra = {})
      described_class.new(dao, extra.with_indifferent_access)
  end

  it 'allows the jira_link to be updated' do
      expect(build(jira_link: 'foo.com').jira_link).to eq('foo.com')
  end
end
