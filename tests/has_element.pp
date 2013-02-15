include stdlib

$my_array = ['key_one']
if has_element($my_array, 'key_two') {
  notice('we will not reach here')
}
if has_element($my_array, 'key_one') {
  notice('this will be printed')
}
