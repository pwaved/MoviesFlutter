import { Model, DataTypes } from 'sequelize';
import sequelize from '../config/db.js';
import User from './users.js';

class Favorite extends Model {
  declare id: number;
  declare user_id: number;
  declare movie_id: number;
}

Favorite.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: User,
      key: 'id',
    },
  },
  movie_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
}, {
  tableName: 'user_favorites',
  sequelize,
  timestamps: false,
});

// Define a associação
User.hasMany(Favorite, { foreignKey: 'user_id' });
Favorite.belongsTo(User, { foreignKey: 'user_id' });

export default Favorite;