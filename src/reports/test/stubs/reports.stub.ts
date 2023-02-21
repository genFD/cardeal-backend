import { Reports } from '../../entities/report.entity';
export const createReportStub = (): Reports => {
  return {
    id: 'reportId',
    price: 32500,
    make: 'Audi',
    model: 'New Model',
    color: 'red',
    transmission: 'automatic',
    fuel_type: 'gasoline',
    year: 2020,
    mileage: 5345,
    approved: false,
    authorId: 'authorId',
  };
};
