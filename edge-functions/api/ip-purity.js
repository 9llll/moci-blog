// EdgeOne Edge Functions - IP 纯净度检测代理
// 路由: /api/ip-purity
// 代理请求 my.ippure.com API，避免 CORS 问题

export default async function onRequest(context) {
    const { request } = context;
    
    // 处理 CORS 预检请求
    if (request.method === 'OPTIONS') {
        return new Response(null, {
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Max-Age': '86400',
            },
        });
    }

    // 只允许 GET 请求
    if (request.method !== 'GET') {
        return new Response(JSON.stringify({ error: 'Method not allowed' }), {
            status: 405,
            headers: { 
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
        });
    }

    try {
        // 获取访客真实 IP
        // EdgeOne 提供 context.request.eo 获取客户端信息
        // 也可以从请求头中获取
        const clientIP = 
            request.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ||
            request.headers.get('cf-connecting-ip') ||
            request.headers.get('x-real-ip') ||
            (context.request.eo?.clientIp) ||
            '';

        if (!clientIP) {
            return new Response(JSON.stringify({ error: '无法获取客户端 IP' }), {
                status: 400,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
            });
        }

        // 代理请求到 ippure.com
        // 使用原始 API 端点，通过 X-Forwarded-For 传递客户端真实 IP
        const apiUrl = 'https://my.ippure.com/v1/info';
        const response = await fetch(apiUrl, {
            headers: {
                'User-Agent': 'Fuwari-Blog/1.0',
                'Accept': 'application/json',
                'X-Forwarded-For': clientIP,
                'X-Real-IP': clientIP,
            },
        });

        if (!response.ok) {
            return new Response(JSON.stringify({ error: 'API 请求失败', status: response.status }), {
                status: response.status,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
            });
        }

        const data = await response.json();

        // 只返回需要的字段
        const result = {
            ip: data.ip,
            fraudScore: data.fraudScore,
            isResidential: data.isResidential,
            isBroadcast: data.isBroadcast,
        };

        return new Response(JSON.stringify(result), {
            status: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'no-cache',
            },
        });
    } catch (error) {
        console.error('IP purity check error:', error);
        return new Response(JSON.stringify({ error: '服务端错误' }), {
            status: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
            },
        });
    }
}
