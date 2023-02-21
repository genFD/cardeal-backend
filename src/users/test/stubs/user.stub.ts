import { Users } from '../../entities/user.entity';
export const createUserStub = (): Users => {
  return {
    id: 'userstubId',
    email: 'userStub@email.com',
    password: 'password',
    admin: false,
  };
};

// export const saveUserStub = (user: {
//   id: string;
//   email: string;
//   password: string;
//   admin: boolean;
// }): Users => {
//   return user;
// };
