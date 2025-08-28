import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth.js';
import favoriteRoutes from './routes/favorites.js';
import sequelize from './config/db.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/users', favoriteRoutes);

const PORT = process.env.PORT || 3000;

// configuracao do sequelize para o banco de dados para o docker 
const startServer = async () => {
  try {
    // Testa a conexão
    await sequelize.authenticate();
    console.log('Conexão com o banco de dados estabelecida com sucesso.');

    // Sincroniza os modelos com o banco de dados.
    // Isso vai criar as tabelas 'users' e 'user_favorites' se elas não existirem.
    await sequelize.sync({ alter: true }); // Use { force: true } para recriar do zero
    console.log("Todos os modelos foram sincronizados com sucesso.");

    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
    });
  } catch (err) {
    console.error('Não foi possível conectar ou sincronizar com o banco de dados:', err);
  }
};

startServer();