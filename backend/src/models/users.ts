import { Model, DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

class User extends Model {
  declare id: number;
  declare email: string;
  declare password_hash: string;
}

User.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  email: {
    type: new DataTypes.STRING(255),
    allowNull: false,
    unique: true,
  },
  password_hash: {
    type: new DataTypes.STRING(255),
    allowNull: false,
  },
}, {
  tableName: 'users',
  sequelize,
  timestamps: false,
});

export default User;