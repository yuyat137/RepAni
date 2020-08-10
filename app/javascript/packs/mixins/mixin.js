export default {
  methods: {
    ConvertSeasonNumberToEnglish(num) {
      switch( num ) {
        case 1:
        case 2:
        case 3:
          return 'winter'
        case 4:
        case 5:
        case 6:
          return 'spring'
        case 7:
        case 8:
        case 9:
          return 'summer'
        case 10:
        case 11:
        case 12:
          return 'autumn'
      }
    }
  },
}
