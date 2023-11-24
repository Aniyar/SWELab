import { http } from './index';

class API {
  async get(endpoint: string) {
    try {
      const response = await http.get(endpoint);
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }

  async post(endpoint: string, data: any) {
    try {
      const response = await http.post(endpoint, data);
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
}

export const api = new API();
