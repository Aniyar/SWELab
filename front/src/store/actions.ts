import { api } from '@/api/endpoint';

export const actions = {
  async getFollowingList() {
    try {
      const response = await api.get('/following');
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  async getFriends() {
    try {
      const response = await api.get('/friends');
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  async getClubList() {
    try {
      const response = await api.get('/club');
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  },
  async getOpenList() {
    try {
      const response = await api.get('/open');
      return response.data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
}
