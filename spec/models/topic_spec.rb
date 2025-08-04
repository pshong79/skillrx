# == Schema Information
#
# Table name: topics
#
#  id              :bigint           not null, primary key
#  description     :text
#  document_prefix :string
#  published_at    :datetime         not null
#  shadow_copy     :boolean          default(FALSE), not null
#  state           :integer          default("active"), not null
#  title           :string           not null
#  uid             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  language_id     :bigint
#  old_id          :integer
#  provider_id     :bigint
#
# Indexes
#
#  index_topics_on_language_id   (language_id)
#  index_topics_on_old_id        (old_id) UNIQUE
#  index_topics_on_provider_id   (provider_id)
#  index_topics_on_published_at  (published_at)
#
require "rails_helper"

RSpec.describe Topic, type: :model do
  subject { create(:topic) }

  context "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:language_id) }
    it { should validate_presence_of(:provider_id) }
  end

  context "associations" do
    it { should have_many_attached(:documents) }
    it { is_expected.to validate_content_type_of(:documents).allowing("image/png", "image/jpeg", "image/svg+xml", "image/webp", "image/avif", "image/gif", "video/mp4") }
    it { is_expected.to validate_size_of(:documents).less_than(200.megabytes) }
  end

  context "tagging" do
    it_behaves_like "taggable"
  end

  describe "#fullname_for_document" do
    subject { create(:topic, :with_documents) }

    let(:document) { subject.documents.first }

    it "generates the correct fullname" do
      expect(subject.fullname_for_document(document))
        .to eq("#{subject.id}_prefix_#{subject.published_at_year}_#{format('%02d', subject.published_at_month)}_test_image.png")
    end
  end
end
