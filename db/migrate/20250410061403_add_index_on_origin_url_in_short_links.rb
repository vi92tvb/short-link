class AddIndexOnOriginUrlInShortLinks < ActiveRecord::Migration[8.0]
  def change
    add_index :short_links, :origin_url, unique: true
  end
end
