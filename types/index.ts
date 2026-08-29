export type Category = { id:string; name:string; image_url:string|null; active:boolean; created_at:string; product_count?:number };
export type Size = { id:string; name:string; active:boolean; created_at:string };
export type Product = { id:string; name:string; team:string; season:string; category_id:string; price:number; description:string; images:string[]; active:boolean; created_at:string; category?:Category };
export type ProductSize = { id:string; product_id:string; size_id:string; active:boolean; size?:Size; stock?:number };
export type StoreSettings = { store_name:string; logo_url:string|null; whatsapp:string; instagram:string };
