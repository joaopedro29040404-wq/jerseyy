import { createClient } from './supabase-server';

export async function getSettings(){ const s=await createClient(); const {data}=await s.from('settings').select('key,value'); const map=Object.fromEntries((data??[]).map(x=>[x.key,x.value])); return {store_name:map.store_name||'JERSEY GOLD',logo_url:map.logo_url||null,whatsapp:map.whatsapp||'',instagram:map.instagram||''}; }
export async function getCategories(){ const s=await createClient(); const {data,error}=await s.from('categories').select('*').eq('active',true).order('created_at',{ascending:false}); if(error) throw error; return data??[]; }
export async function getSizes(){ const s=await createClient(); const {data,error}=await s.from('sizes').select('*').eq('active',true).order('name'); if(error) throw error; return data??[]; }
export async function getProducts(){ const s=await createClient(); const {data,error}=await s.from('products').select('*, category:categories(*), product_sizes(*, size:sizes(*), product_size_stock(stock))').eq('active',true).order('created_at',{ascending:false}); if(error) throw error; return data??[]; }
export async function getProduct(id:string){ const s=await createClient(); const {data,error}=await s.from('products').select('*, category:categories(*), product_sizes(*, size:sizes(*), product_size_stock(stock))').eq('id',id).single(); if(error) return null; return data; }
