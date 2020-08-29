import axios from 'axios'

const axiosInstance = axios.create({
  baseURL:  window.location.protocol + "//" + window.location.host + "/api"
})

export default axiosInstance
