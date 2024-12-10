class AddSortToBannerNewstickerCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :sort, :integer, default: 1
    add_column :news_tickers, :sort, :integer, default: 1
    add_column :categories, :sort, :integer, default: 1
  end
end
