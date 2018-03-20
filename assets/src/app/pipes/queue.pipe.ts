import { Pipe, PipeTransform } from '@angular/core';
/*
 * Usage:
 *   value | queue
 * Example:
 *   {{ 'job_ftp' | queue }}
 *   formats to: "FTP jobs"
*/
@Pipe({name: 'queue'})
export class QueuePipe implements PipeTransform {

  transform(queue: string): string {
    var allQueueNames = [
      { id: 'job_ftp', name: 'FTP jobs' },
      { id: 'job_ftp_error', name: 'FTP jobs with error status' },
      { id: 'job_ftp_completed', name: 'FTP jobs with completed status' },
      { id: 'job_gpac', name: 'DASH generation jobs' },
      { id: 'job_gpac_error', name: 'DASH jobs with error status' },
      { id: 'job_gpac_completed', name: 'DASH jobs with completed status' },
      { id: 'job_http', name: 'HTTP jobs' },
      { id: 'job_http_error', name: 'HTTP jobs with error status' },
      { id: 'job_http_completed', name: 'HTTP jobs with completed status' },
    ];

    for (var i = allQueueNames.length - 1; i >= 0; i--) {
      if(allQueueNames[i].id == queue){
        return allQueueNames[i].name;
      }
    }
    return queue;
  }
}