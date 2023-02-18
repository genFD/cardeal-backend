import { Users } from '../../entities/user.entity';
export const createUserStub = (): Users => {
  return {
    id: 'userstubId',
    email: 'userStub@email.com',
    password: 'password',
    admin: false,
  };
};
