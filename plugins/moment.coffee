import Vue from 'vue'
import numeral from 'numeral'
import moment from 'moment'

Plugin = {}

Plugin.install = (vue, options) ->

  vue.filter 'numeral', (text, format='0,0') ->
    numeral(text).format format

  vue.filter 'moment', (text, format='D MMM YYYY', fromFormat) ->
    if fromFormat?
      date = moment text, fromFormat
    else
      date = moment text
    return date.format format

Vue.use Plugin
