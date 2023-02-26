import { Reports } from '../../reports/entities/report.entity';

export const PrismaService = jest.fn().mockReturnValue({
  report: {
    // create: jest.fn((report: Reports) => {
    //   console.log(report);

    //   return Promise.resolve(report);
    // }),
    create: jest.fn((report: Reports) => {
      return report;
    }),
    update: jest.fn((id, approved) => {
      return { approved: approved };
    }),
  },
  user: {
    create: () => {
      console.log('new user');
    },
  },
});
