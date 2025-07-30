import axios, { type AxiosInstance } from "axios";

// change the baseURL to whatever your resource is called
// example -> baseURL: "https://<resource_name_here>/"
// connection has to be secure ( HTTPS )
const Axios: AxiosInstance = axios.create({
  baseURL: "https://es_fleeca/",
});

export default Axios;