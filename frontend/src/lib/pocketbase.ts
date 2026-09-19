import PocketBase from 'pocketbase';

// Para o desenvolvimento local, liga-se ao porto 8090.
// Em produção (Docker), pode usar uma variável de ambiente pública do Vite/Astro.
const PB_URL = import.meta.env.PUBLIC_POCKETBASE_URL || 'http://localhost:8055';

export const pb = new PocketBase(PB_URL);

// Opcional: Para ambientes com auth
// pb.autoCancellation(false);
