context('Geohash decoder')

test_that('geohash decoder works', {
  borobudur = 'qqwkex'
  akarenga = 'xpkjd5'
  kalakuta = 's14mh7y'
  neum = 'srss0'

  # test defaults on scalar input
  expect_equal(gh_decode(borobudur),
               list(latitude = -7.60528564453125,
                    longitude = 110.1983642578125))
  expect_equal(gh_decode(c(borobudur, akarenga)),
               list(latitude = c(-7.60528564453125, 41.7672729492188),
                    longitude = c(110.198364257812, 140.718383789062)))
  ## precision can vary
  expect_equal(gh_decode(c(borobudur, neum)),
               list(latitude = c(-7.60528564453125, 42.91259765625),
                    longitude = c(110.198364257812, 17.60009765625)))

  # option: include_delta
  expect_equal(gh_decode(borobudur, include_delta = TRUE),
               list(latitude = -7.60528564453125,
                    longitude = 110.198364257812,
                    delta_latitude = 0.00274658203125,
                    delta_longitude = 0.0054931640625))
  ## different precision, different delta
  expect_equal(gh_decode(c(borobudur, neum), include_delta = TRUE),
               list(latitude = c(-7.60528564453125, 42.91259765625),
                    longitude = c(110.198364257812, 17.60009765625),
                    delta_latitude = c(0.00274658203125, 0.02197265625),
                    delta_longitude = c(0.0054931640625, 0.02197265625)))

  # option: coord_loc
  expect_equal(gh_decode(borobudur, coord_loc = 'se'),
               list(latitude = -7.6080322265625, longitude = 110.203857421875))
  expect_equal(gh_decode(borobudur, coord_loc = 'southeast'),
               list(latitude = -7.6080322265625, longitude = 110.203857421875))
  expect_equal(gh_decode(borobudur, coord_loc = 's'),
               list(latitude = -7.6080322265625, longitude = 110.198364257812))
  expect_equal(gh_decode(borobudur, coord_loc = 'south'),
               list(latitude = -7.6080322265625, longitude = 110.198364257812))
  expect_equal(gh_decode(borobudur, coord_loc = 'sw'),
               list(latitude = -7.6080322265625, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'southwest'),
               list(latitude = -7.6080322265625, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'w'),
               list(latitude = -7.60528564453125, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'west'),
               list(latitude = -7.60528564453125, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'nw'),
               list(latitude = -7.6025390625, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'northwest'),
               list(latitude = -7.6025390625, longitude = 110.19287109375))
  expect_equal(gh_decode(borobudur, coord_loc = 'n'),
               list(latitude = -7.6025390625, longitude = 110.198364257812))
  expect_equal(gh_decode(borobudur, coord_loc = 'north'),
               list(latitude = -7.6025390625, longitude = 110.198364257812))
  expect_equal(gh_decode(borobudur, coord_loc = 'ne'),
               list(latitude = -7.6025390625, longitude = 110.203857421875))
  expect_equal(gh_decode(borobudur, coord_loc = 'northeast'),
               list(latitude = -7.6025390625, longitude = 110.203857421875))
  expect_equal(gh_decode(borobudur, coord_loc = 'e'),
               list(latitude = -7.60528564453125, longitude = 110.203857421875))
  expect_equal(gh_decode(borobudur, coord_loc = 'east'),
               list(latitude = -7.60528564453125, longitude = 110.203857421875))

  # be sure adjacent geohashes interlock
  expect_equal(lapply(c('nw', 'n', 'ne'),
                      function(l) gh_decode('m', coord_loc = l)),
               lapply(c('sw', 's', 'se'),
                      function(l) gh_decode('t', coord_loc = l)))

  expect_error(gh_decode(c(borobudur, neum), coord_loc = c('n', 's')),
               'Please provide only one value', fixed = TRUE)
  expect_error(gh_decode(akarenga, coord_loc = 'yo'),
               error = 'Unrecognized coordinate location')

  # invalid geohash characters:
  expect_error(gh_decode('a'), fixed = TRUE,
               "Invalid geohash; check 'a' at index 1.")
  expect_error(gh_decode(c('b', 'a')), fixed = TRUE,
               "Invalid geohash; check 'a' at index 2.")

  # missing input
  expect_equal(gh_decode(c(neum, NA_character_)),
               list(latitude = c(42.91259765625, NA),
                    longitude = c(17.60009765625, NA)))
  expect_equal(gh_decode(c(neum, NA_character_), include_delta = TRUE),
               list(latitude = c(42.91259765625, NA),
                    longitude = c(17.60009765625, NA),
                    delta_latitude = c(0.02197265625, NA),
                    delta_longitude = c(0.02197265625, NA)))

  # empty input
  expect_equal(gh_decode(character(0L)),
               list(latitude = numeric(0L), longitude = numeric(0L)))
})