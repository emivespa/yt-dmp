import sys
import json
sys.path.insert(0, './deps')
import yt_dlp

# TODO: CORS?
# TODO: work with both

def lambda_handler(event, context):
    try:
        proxy = event['pathParameters']['proxy']
        proxy = proxy.split('=')[-1] # Accept both video links and IDs.
        url = f'https://www.youtube.com/watch?v={proxy}'
        ydl_opts = {
            'dumpjson': True,
            'geo_bypass': True,
            'no_call_home': True,
        }
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            data = ydl.extract_info(url, download=False)
        return {
            'statusCode': 200,
            'body': json.dumps(data),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
