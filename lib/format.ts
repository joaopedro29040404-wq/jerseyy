export function money(value:number){ return new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(value); }
export function whatsappUrl(number:string, message:string){ const digits=number.replace(/\D/g,''); return `https://wa.me/${digits}?text=${encodeURIComponent(message)}`; }
