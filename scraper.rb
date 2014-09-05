# This is a template for a Ruby scraper on Morph (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
#
agent = Mechanize.new
#
# # Read in a page
page = agent.get("http://www.elections.org.nz/parties-candidates/registered-political-parties/register-political-parties")
#
# # Find somehing on the page using css selectors
page.search(".party-bio-content").each do |p|
	name = p.at("h3:contains('Abbreviation') + p").inner_text
	if name == 'none'
		name = p.at('h2 a').inner_text
	end
	next if name.empty?
	party = {
		'name' => name,
		'logo' => p.at('.party-logo img').attr('href')
	}
	ScraperWiki.save_sqlite(['name'], party)
	puts "Saved record for #{party['name']}"
end

# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries. You can use whatever gems are installed
# on Morph for Ruby (https://github.com/openaustralia/morph-docker-ruby/blob/master/Gemfile) and all that matters
# is that your final data is written to an Sqlite database called data.sqlite in the current working directory which
# has at least a table called data.
