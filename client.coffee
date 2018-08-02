console.log 'up!'

# this is the not stuff you want to configure! configurables are at the bottom.

searchParameters = {
  query: '',
  categories: [],
  subcategories: [],
  search_types: [],
  difficulties: [],
  tournaments: []
}
readSpeed = 120
currentlyIsBuzzing = false
questionEnded = false
questionFinished = false
questionAnswered = false
questions = null
question = null
questionText = null
readInterval = null
word = 0

next = () ->
  finish()
  questionEnded = false
  questionFinished = false
  question = questions[(questions.indexOf(question) + 1) % questions.length]
  $('#metadata').empty()
  $('#metadata').append('<li class="breadcrumb-item">'+question.year+' '+question.tournament'</li>')
  $('#metadata').append('<li class="breadcrumb-item">'+question.difficulty+'</li>')
  $('#metadata').append('<li class="breadcrumb-item">'+question.category+'</li>')
  $('#metadata').append('<li class="breadcrumb-item">'+question.subcategory+'</li>')
  questionText = question.text.question.split(' ')
  $('#question').text('');
  $('#answer').text('');
  readInterval = window.setInterval () ->
    if currentlyIsBuzzing or questionFinished or questionEnded
      return
    $('#question').append(questionText[word] + ' ')
    word++
    if word == questionText.length
      questionEnded = true
    return
  , readSpeed
  return

finish = () ->
  questionEnded = true
  questionFinished = true
  window.clearInterval(readInterval)
  if questionText?
    while word < questionText.length
      $('#question').append(questionText[word] + ' ')
      word++
  word = 0
  $('#answer').text(question.text.answer) if question?
  return

search = () ->
  url = '!'
  url += searchParameters.query
  url += '!'
  url += searchParameters.categories
  url += '!'
  url += searchParameters.subcategories
  url += '!'
  url += searchParameters.tournaments
  url += '!'
  url += searchParameters.searchType
  finish()
  $('#question').text('this may take a while...')
  $('#answer').text('')
  console.log url
  $.getJSON 'search/'+url, (res) ->
    questions = res
    console.log questions
    question = null
    next()
    return
  return

$(document).ready () ->
  $(document).keyup () ->
    # these are the configurables!
    searchParameters = {
      query: $('#query').val(),
      categories: $('#categories').val(),
      subcategories: $('#subcategories').val(),
      difficulties: $('#difficulties').val(),
      tournaments: $('#tournaments').val(),
      searchType: $('#searchType').find(':selected').val()
    }
    readSpeed = 120 # number of milliseconds between words
    # end configurables
    if event.which == 32
      if currentlyIsBuzzing and not questionFinished
        finish()
        currentlyIsBuzzing = false
      else if not questionFinished
        $('#question').append('(#) ')
        currentlyIsBuzzing = true
    else if event.which == 78
      next()
    else if event.which == 83
      search()
    setTimeout () ->
      window.scrollTo 0, 0
      return
    , 30
    return
  return

