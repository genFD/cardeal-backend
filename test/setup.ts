import resetDb from './reset-db';

global.beforeEach(async () => {
  await resetDb();
});
