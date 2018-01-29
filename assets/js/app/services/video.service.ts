import { Injectable } from '@angular/core';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { catchError, map, tap } from 'rxjs/operators';

import {VideoPage} from './video_page';

@Injectable()
export class VideoService {
  private videosUrl = 'api/videos';

  constructor(private http: HttpClient) { }

  getVideos(page, channels): Observable<VideoPage> {
    let params = new HttpParams();
    params = params.append("per_page", "10");
    params = params.append("type.id", "integrale");
    params = params.append("channels[]", channels);
    if(page > 0) {
      params = params.append('page', page + 1);
    }

    return this.http.get<VideoPage>(this.videosUrl, {params: params})
      .pipe(
        tap(videopage => this.log("fetched VideoPage")),
        catchError(this.handleError('getVideos', undefined))
      );
  }

  private handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      this.log(`${operation} failed: ${error.message}`);
      return of(result as T);
    };
  }

  private log(message: string) {
    console.log('VideoService: ' + message);
  }
}
