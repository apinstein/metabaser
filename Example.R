require(metabaser)

mb_session <- metabase_init('https://metabase.metabaser.dne', 'email@metabaser.dne')

data <- metabase_fetch_question(mb_session, 242)
data
